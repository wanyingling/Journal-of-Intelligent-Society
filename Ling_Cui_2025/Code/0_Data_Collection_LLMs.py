"""
 * Program: 复现的限度："硅基样本"的可能与可为
 * Author: Wanying Ling, Sizhan Cui
 * Created: 2/10/2025
 * Revised: 2/22/2025
"""

import pandas as pd
from openai import OpenAI
import os

# 初始化 OpenAI 客户端
client = OpenAI(
    api_key="", # 替换成自己的API
    base_url="", # 替换成自己的URL
)

# 加载数据集
data = pd.read_csv("../Working_data/...") # 加载对应的数据集

# 如果数据中不存在相关列，则添加
if "Prompt" not in data.columns:
    data["Prompt"] = None
if "medconf_LLMs" not in data.columns:
    data["medconf_LLMs"] = None


def generate_prompt(row):
    prompt = f"""
    今年是{row['year']}年，您是一位{row['age']}岁的中国{row['gender']}。目前您居住在{row['prov']}的{row['residtype']}，户口类型为{row['hukou']}。
    您的最高学历为{row['education']}，当前的工作状态是{row['work']}，婚姻状况为{row['marrstatus']}，{row['child']}。 
    在健康与医疗方面，您认为自己的总体健康状况{row['health']}，并且您{row['illness']}，{row['medinsur']}。
    过去12个月中，您{row['chinesemed']}看中医，{row['westernmed']}看西医。您{row['notgetmed']}的经历。

    基于以上背景信息，请回答以下单选题：
    Q1：总的来说，您对中国的医疗卫生有多大的信心？
    选项：
    1. 完全有信心
    2. 有很大信心
    3. 有一些信心
    4. 几乎没信心
    5. 完全没有信心
    """
    return prompt.strip()


def query_llm(prompt):
    try:
        response = client.chat.completions.create(
            model="", # 替换为对应的模型
            messages=[
                {"role": "system", "content": "您是一名社会调查受访者。请根据提供的背景信息，选择最符合您情况的选项。"},
                {"role": "user", "content": prompt},
            ],
        )
        return response.choices[0].message.content.strip()
    except Exception as e:
        print(f"查询 LLM 时出错：{e}")
        return None


# 输出文件路径
output_file = "../Working_data/LLMs.csv"

# 指定要保存的列
columns_to_save = [
    "ID",
    "year",
    "age",
    "gender",
    "prov",
    "residtype",
    "hukou",
    "education",
    "work",
    "marrstatus",
    "child",
    "health",
    "illness",
    "chinesemed",
    "westernmed",
    "notgetmed",
    "medinsur",
    "medconf",
    "weight",
    "weight_raking",
    "Prompt",
    "medconf_LLMs"
]

# 如果输出文件不存在，则创建文件并写入表头
if not os.path.exists(output_file):
    data[columns_to_save].iloc[:0].to_csv(output_file, index=False, encoding='utf-8-sig')

# 处理每位受访者
for index, row in data.iterrows():
    prompt = generate_prompt(row)
    response = query_llm(prompt)

    # 更新数据
    row["Prompt"] = prompt
    row["medconf_LLMs"] = response

    # 保存到CSV文件
    row[columns_to_save].to_frame().T.to_csv(output_file, mode="a", header=False, index=False, encoding='utf-8-sig')

    print(f"已处理受访者 {index + 1}/{len(data)}")


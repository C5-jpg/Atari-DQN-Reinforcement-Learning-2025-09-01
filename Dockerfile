# 使用Miniconda基础镜像
FROM continuumio/miniconda3:latest

# 设置工作目录
WORKDIR /app

# 复制conda环境包
COPY atari_env.tar.gz /tmp/

# 解压环境到指定目录
RUN mkdir -p /opt/conda/envs && \
    tar -xzf /tmp/atari_env.tar.gz -C /opt/conda/envs && \
    rm /tmp/atari_env.tar.gz

# 设置环境变量
ENV PATH /opt/conda/envs/atari/bin:$PATH
ENV CONDA_DEFAULT_ENV atari

# 复制ROM文件
COPY ROMS /opt/conda/envs/atari/lib/python3.9/site-packages/ale_py/roms/

# 安装Jupyter（可选，用于交互式开发）
RUN pip install jupyter

# 暴露端口（可选）
EXPOSE 8888

# 设置默认命令
CMD ["/bin/bash"]

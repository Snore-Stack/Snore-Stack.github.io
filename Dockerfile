FROM squidfunk/mkdocs-material:9
RUN git config --global --add safe.directory '*' \
    && pip install --no-cache-dir mkdocs-git-committers-plugin-2

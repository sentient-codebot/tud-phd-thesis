FROM registry.gitlab.com/novanext/base-docker:2025 AS base

ADD ./_python /_python
RUN python3 -m pip install -Ur _python/requirements.txt
RUN python3 -c "from matplotlib import font_manager"

# build locally and use interactively as:
# docker build -t tud-dissertation .
# docker run -it --rm -v $(pwd):/code tud-dissertation bash

# or download from gitlab and use locally:
# docker run -it --rm -v $(pwd):/code --platform=linux/amd64 registry.gitlab.com/novanext/tudelft-dissertation:master

# To create a user (for GUI applications)
# useradd -m -G sudo novanext
# echo 'novanext:novanext' | chpasswd

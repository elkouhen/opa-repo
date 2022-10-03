FROM gitpod/workspace-full
USER gitpod
RUN sudo apt-get update -q

COPY --from=openpolicyagent/conftest:v0.34.0 /conftest /usr/local/bin/conftest

COPY --from=hairyhenderson/gomplate /gomplate /usr/local/bin/gomplate
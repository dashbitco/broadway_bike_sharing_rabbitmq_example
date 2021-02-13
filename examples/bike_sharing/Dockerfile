FROM hexpm/elixir:1.11.2-erlang-23.1.4-ubuntu-focal-20201008

RUN apt-get update && mix local.rebar --force && mix local.hex --force

WORKDIR /app

COPY mix.exs mix.lock /app/

RUN mix deps.get

ADD . .

RUN mix compile

CMD ["mix", "run", "--no-halt", "./priv/publish_sample_events.exs"]

# Hacker News Aggregator

The Hacker News Aggregator fetches top stories from Hacker News Api and makes available
into endpoints and websocket.

## API Reference

#### Get paginated top stories from **Hacker News**

```http
  GET /top_stories?page=${page}
```

| Parameter | Type     | Description                |
| :-------- | :------- | :------------------------- |
|  `page`   | `string` |  **Required**. Page number |

- Response:
```json
{
  "page": 1,
  "top_stories": [
    30604470,
    30605252,
    30605356,
    30598762,
    30605010,
    30600525,
    30608457,
    30602060,
    30604447,
    30607692
  ],
  "total_pages": 5
}
```

#### Get item

```http
  GET /item/${id}
```

- Response:
```json
{
  "by": "tejohnso",
  "descendants": 528,
  "id": 30293622,
  "kids": [
    30293946,
    30294297,
    30295699,
    30294081,
    ...
    30297616
  ],
  "score": 460,
  "time": 1644532159,
  "title": "Case against OOP is understated, not overstated (2020)",
  "type": "story",
  "url": "https://boxbase.org/entries/2020/aug/3/case-against-oop/"
}
```

| Parameter | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| `id`      | `string` | **Required**. Id of item to fetch |

### Websocket

```http
  ws://localhost:4001/ws/top_stories
```

- Response (array of top stories):
```json
[30660534,30659164,30660203,30660000,30656961, ..., 30631605]
```

## Run Locally

Clone the project

```bash
  git clone git@github.com:leandronishijima/ex_hacker_news_aggregator.git
```

Go to the project directory

```bash
  cd ex_hacker_news_aggregator
```

Install elixir/erlang versions / dependencies

**If you use asdf manager**
```bash
  asdf install
```

**If you don't, use this versions:**

````
elixir 1.12.3-otp-23
erlang 23.3.4.10
````

- Install the dependencies:

```bash
  mix deps.get
```

Start the server

```bash
  iex -S mix
```

## Running Tests

To run tests, run the following command

```bash
  mix test
```

## Release

To generate release for this project run

```bash
  MIX_ENV=prod mix release hacker_news_aggregator
```

To run the artifact 

```bash
  _build/prod/rel/hacker_news_aggregator/bin/hacker_news_aggregator start
```

## Tech Stack

**Lang:** Elixir

- [plug_cowboy](https://hex.pm/packages/plug_cowboy)
- [tesla](https://hex.pm/packages/tesla)
- [jason](https://hex.pm/packages/jason)
- [mox](https://hex.pm/packages/mox)
- [credo](https://hex.pm/packages/credo)

# 誰だお前？明石？
import os

try:
    os.environ["LLVM_TARGET_TRIPLE_SUFFIX"]
    print("シミュレータ試験です。大淀には知らせないでおきますね")
except KeyError:
    print("実機インストールです。大淀に知らせますね!")

    # 必要ライブラリインポート
    import urllib.request as request
    import json
    import time
    # 実機インストールが無効になる日
    deadline_tmp = time.localtime(time.time() + 86400 * 7)
    deadline = time.strftime("%Y/%m/%d", deadline_tmp)
    # content作成
    content = {
        # "channel": "#app-test",
        "text": "提督、新しい端末の有効期限は" + deadline + "です。"
    }
    header = {
        "Content-Type": "application/json"
    }
    # url
    WEBHOOK_URL = "https://hooks.slack.com/services/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"
    req = request.Request(WEBHOOK_URL, json.dumps(content).encode(), header)
    with request.urlopen(req) as res:
        print(res.read())

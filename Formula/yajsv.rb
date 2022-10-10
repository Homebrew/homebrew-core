class Yajsv < Formula
  desc "Yet Another JSON Schema Validator"
  homepage "https://github.com/neilpa/yajsv"
  url "https://github.com/neilpa/yajsv/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "08118f3614231f3c5f86f4f68816e706e120b8c91cdf6c1caaea45a71e3e5943"
  license "MIT"
  head "https://github.com/neilpa/yajsv.git", branch: "master"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"schema.json").write '{"type": "null"}'
    (testpath/"null.json").write "null"
    assert_match "null.json: pass", shell_output("#{bin}/yajsv -s #{testpath}/schema.json #{testpath}/null.json")
    (testpath/"true.json").write "true"
    assert_match "true.json: fail: (root): Invalid type",
                 shell_output("#{bin}/yajsv -s #{testpath}/schema.json #{testpath}/true.json", 1)
  end
end

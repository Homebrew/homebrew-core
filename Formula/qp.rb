class Qp < Formula
  desc "The query-pipe: command-line (ND)JSON querying"
  homepage "https://github.com/paybase/qp"
  url "https://github.com/paybase/qp/releases/download/1.0.1/qp-1.0.1-darwin.tar.gz"
  sha256 "a4a5e6caa86b99fc54bf8db8d36def3b64ffbea5b03de094ec8db423425d8401"

  def install
    mkdir bin.to_s
    cp "./qp", bin.to_s
  end

  test do
    assert_equal "{\"id\":1}\n", pipe_output("#{bin}/qp 'select id'", "{\"id\": 1, \"name\": \"test\"}")
  end
end

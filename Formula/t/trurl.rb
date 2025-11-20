class Trurl < Formula
  desc "Command-line tool for URL parsing and manipulation"
  homepage "https://curl.se/trurl/"
  url "https://github.com/curl/trurl/releases/download/trurl-0.16.1/trurl-0.16.1.tar.gz"
  sha256 "aac947d4fb421a58abc19a3771e87942cd4721b8f855c433478c94c11a8203ba"
  license "curl"
  head "https://github.com/curl/trurl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b85273354bcc4088546ae4bef82d933579d8c81fd9f77c0403e2a4402c63a476"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e77852df0afaaf260ec8a9bba1c4b0536866a72c0d6d4070fea5f344aa81070"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd620f42f89c0bb12b9db5a1f139a949c8db111752e951f40089c9221c9c2ef3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fb1195a085b9698e6b1989fe970d8156d75041e1e0b57a035ca198398ca4abae"
    sha256 cellar: :any_skip_relocation, sonoma:        "f7e5d221285006395dcc352f22faa4f34600b73cc012d3686bce0584c74f703e"
    sha256 cellar: :any_skip_relocation, ventura:       "76a64a6398d7e7ef61f8140c04a6d777b3248326579aa5a22c0ba276e69ab042"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d50283a36a33f49b589c407d7c5dde5081b4f2aab28f4a499804914d0d247c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cdfb216b12de94af1ec6da70bf70ff6260f5638c8efb552c503082ba86ec230"
  end

  uses_from_macos "curl", since: :ventura # uses CURLUE_NO_ZONEID, available since curl 7.81.0

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    output = shell_output("#{bin}/trurl https://example.com/hello.html " \
                          "--default-port --get '{scheme} {port} {path}'").chomp
    assert_equal "https 443 /hello.html", output
  end
end

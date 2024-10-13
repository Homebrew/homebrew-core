class Vapor < Formula
  desc "Command-line tool for Vapor (Server-side Swift web framework)"
  homepage "https://vapor.codes"
  url "https://github.com/vapor/toolbox/archive/refs/tags/18.7.5.tar.gz"
  sha256 "0322fee24872b713e1e495070e6b7b1fca468bed19f48bcf7a1397ffdf701e9a"
  license "MIT"
  head "https://github.com/vapor/toolbox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "a0ba1020b0ae6649763e9867b853fe2161863afadb888717d626d628797e29ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5d0e1fa0fe4b21022520634975d94938e6cbb98938d3a0491b28303455c26119"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "16d95898c8fe2ef2354f3dcb09121378b9960fede73a3ddb6e3c44d32a235bd1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "729bf1f69c66f2514b731679a62128f3ab3a4304434abb6b736ef8f17469fad7"
    sha256 cellar: :any_skip_relocation, sonoma:         "2f26a2c257e662740907c1e492724e47ec789292c602230d27f0e35aefa1187a"
    sha256 cellar: :any_skip_relocation, ventura:        "100e8c3e9fd7c55f2e053445e538a16dc50be4bbf11953888414dd5fe31cd1ae"
    sha256 cellar: :any_skip_relocation, monterey:       "5ca5c14a0b6e0ebc2cd2959159d860e8204afd6781f1096e02fe15de60a6e848"
    sha256                               x86_64_linux:   "5fa1012bd4dfc0b19e96a3337f5fa61139e960321fc95e1a79df4476c221a8e7"
  end

  # vapor requires Swift 5.6.0
  depends_on xcode: "13.3"

  uses_from_macos "swift", since: :big_sur

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "-Xswiftc",
      "-cross-module-optimization", "--enable-test-discovery"
    mv ".build/release/vapor", "vapor"
    bin.install "vapor"
  end

  test do
    system bin/"vapor", "new", "hello-world", "-n"
    assert_predicate testpath/"hello-world/Package.swift", :exist?
  end
end

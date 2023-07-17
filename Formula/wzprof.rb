class Wzprof < Formula
  desc "Profiling for Wazero"
  homepage "https://github.com/stealthrocket/wzprof"
  url "https://github.com/stealthrocket/wzprof/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "20223095b6b0bcb7ee655e755d2979f743a1bd03bf4fb09928856356caa9d463"
  license "Apache-2.0"
  head "https://github.com/stealthrocket/wzprof.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f8d9399ca250920f073e0c6f2d821a8e8681e81c5029071ee8f8943412ce77d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f8d9399ca250920f073e0c6f2d821a8e8681e81c5029071ee8f8943412ce77d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2f8d9399ca250920f073e0c6f2d821a8e8681e81c5029071ee8f8943412ce77d"
    sha256 cellar: :any_skip_relocation, ventura:        "8b4e097e071ae5e9900bcfb3f8cbd7574c70acfbd6baf26e5eadce385fbe67a0"
    sha256 cellar: :any_skip_relocation, monterey:       "8b4e097e071ae5e9900bcfb3f8cbd7574c70acfbd6baf26e5eadce385fbe67a0"
    sha256 cellar: :any_skip_relocation, big_sur:        "8b4e097e071ae5e9900bcfb3f8cbd7574c70acfbd6baf26e5eadce385fbe67a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00a4b0daa0c7d11abb4dbdd683cff224c544a5e9602ae2d187a56f1637736399"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/wzprof"
  end

  test do
    resource "simple.wasm" do
      url "https://github.com/stealthrocket/wzprof/raw/c2e9f22/testdata/c/simple.wasm"
      sha256 "f838a6edabfc830177f10f8cba0a07f36bb1d81209d4300f6d41ad2305756b3a"
    end

    testpath.install resource("simple.wasm")
    expected = <<~EOS
      start
      func1 malloc(10): 0x11500
      func21 malloc(20): 0x11510
      func31 malloc(30): 0x11530
      end
    EOS
    assert_equal expected, shell_output(bin/"wzprof -sample 1 #{testpath}/simple.wasm 2>&1")

    assert_match "wzprof version #{version}", shell_output(bin/"wzprof -version")
  end
end

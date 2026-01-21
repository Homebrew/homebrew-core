class Wzprof < Formula
  desc "Profiling for Wazero"
  homepage "https://github.com/dispatchrun/wzprof"
  url "https://github.com/dispatchrun/wzprof/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "20223095b6b0bcb7ee655e755d2979f743a1bd03bf4fb09928856356caa9d463"
  license "Apache-2.0"
  head "https://github.com/dispatchrun/wzprof.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "1730b8de6730863c0725a3468613f2d9c5ad5165da36a44b134b1f30ccbe2012"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "09412fe4df2eeb2fa3e05a8da39a192f7bb5e38b98ef5c6924f93dd50b8c6abe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "75f3a9f0120d54457ee0a116bcfb52147831bb466ef1b7cba2db1bdda93401ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e5cd9073cd439d27d735796f4f88ca53e320d00767202195df23a151cd207f7e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5cd9073cd439d27d735796f4f88ca53e320d00767202195df23a151cd207f7e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e5cd9073cd439d27d735796f4f88ca53e320d00767202195df23a151cd207f7e"
    sha256 cellar: :any_skip_relocation, sonoma:         "e81bdeda7ca477bd619d663d733abf9a551a50c684e9a3f41967617160067428"
    sha256 cellar: :any_skip_relocation, ventura:        "38d8f01a22a239c240d6e00db065fc8036f5ae039501925ec0df0a0366983bba"
    sha256 cellar: :any_skip_relocation, monterey:       "38d8f01a22a239c240d6e00db065fc8036f5ae039501925ec0df0a0366983bba"
    sha256 cellar: :any_skip_relocation, big_sur:        "38d8f01a22a239c240d6e00db065fc8036f5ae039501925ec0df0a0366983bba"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "1387c049a3862b7cf8daee964ed611fb4a6c4a77756b91d1e9d538447c6f70ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a163de238c1aa3233c725104f4a523cc26d6fd30c5c132d4e408415bdce3ac1d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/wzprof"
  end

  test do
    resource "simple.wasm" do
      url "https://github.com/dispatchrun/wzprof/raw/c2e9f22/testdata/c/simple.wasm"
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
    assert_equal expected, shell_output("#{bin}/wzprof -sample 1 #{testpath}/simple.wasm 2>&1")

    assert_match "wzprof version #{version}", shell_output("#{bin}/wzprof -version")
  end
end

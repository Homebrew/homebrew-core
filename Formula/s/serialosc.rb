class Serialosc < Formula
  desc "Opensound control server for monome devices"
  homepage "https://github.com/monome/docs/blob/gh-pages/serialosc/osc.md"
  # pull from git tag to get submodules
  url "https://github.com/monome/serialosc.git",
      tag:      "v1.4.8",
      revision: "c96ea389dbf82c84d17f6f7adddaf311aed49438"
  license "ISC"
  revision 1
  head "https://github.com/monome/serialosc.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4cc5b45d18995e43b2b62ea34526b40bc9a5d0df5f532de66d78561a58f98760"
    sha256 cellar: :any, arm64_tahoe:       "3f19816658fa50919906a72e6d4785939ff5518e7c2372bfe809d22f4ea58491"
    sha256 cellar: :any, arm64_sequoia:     "0876506d909bde218a5d22455974763dd822ce6bc41815d5870657347ba29347"
    sha256 cellar: :any, arm64_sonoma:      "e3821fc60e00ff0b9dd4ff0161467c0dd3e9fc0cb8de78d22447e1b54568fda6"
    sha256 cellar: :any, arm64_linux:       "2c5a518ea1f48ffc9513feeca36ac2d4d69927503db139ba1f92b2342027594c"
    sha256 cellar: :any, x86_64_linux:      "cfc9138dccdd02c3ab0ff9b21add7a026fc8e7c7c4eeb1b284425a18ad84bb87"
  end

  depends_on "liblo"
  depends_on "libmonome"
  depends_on "libuv"

  uses_from_macos "python" => :build

  on_linux do
    depends_on "avahi" => :no_linkage # dlopen("libdns_sd.so")
    depends_on "systemd" # for libudev
  end

  def install
    system "python3", "./waf", "configure", "--prefix=#{prefix}"
    system "python3", "./waf", "build"
    system "python3", "./waf", "install"
  end

  service do
    run [opt_bin/"serialoscd"]
    keep_alive true
    log_path var/"log/serialoscd.log"
    error_log_path var/"log/serialoscd.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/serialoscd -v")
  end
end

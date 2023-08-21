class Serialosc < Formula
  desc "Opensound control server for monome devices"
  homepage "https://github.com/monome/docs/blob/gh-pages/serialosc/osc.md"
  # pull from git tag to get submodules
  url "https://github.com/monome/serialosc.git",
      tag:      "v1.4.3",
      revision: "12fa410a14b2759617c6df2ff9088bc79b3ee8de"
  license "ISC"
  head "https://github.com/monome/serialosc.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "3080c9badf496b7befff93f8a00d58fa83ce0de652bb0eb08296b409491b2efb"
    sha256 cellar: :any,                 arm64_monterey: "318e77a4ee30e5b95315e2d05ee4967400fabc94cfb9621961f425132fa96f78"
    sha256 cellar: :any,                 arm64_big_sur:  "f5b5a750553afaad105661c6c3a1d863bd18e89a6c1f818877e09fab50798e23"
    sha256 cellar: :any,                 ventura:        "740a5861d890f439eab1812de773d574c27dac4581db94ccbb09a1c3acb70077"
    sha256 cellar: :any,                 monterey:       "cf20c8747d7be7d4fea6709348af811a25f7e82c40ec462f6f2fe746951da665"
    sha256 cellar: :any,                 big_sur:        "dd151339ca334c6719b61216a4ca378f1980079de8b7d666a7b544aa3eb71484"
    sha256 cellar: :any,                 catalina:       "8f47b03bae3c5309d74a3032264246f33e9c05141b6679a057b9cfbc0fa3a8c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a80b151ced619522b991261dfb4a40a18acd6b47a02c82a2748fe13b29636813"
  end

  depends_on "confuse"
  depends_on "liblo"
  depends_on "libmonome"
  depends_on "libuv"

  uses_from_macos "python" => :build

  on_linux do
    depends_on "avahi"
    depends_on "systemd" # for libudev
  end

  def install
    system "python3", "./waf", "configure", "--enable-system-libuv", "--prefix=#{prefix}"
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

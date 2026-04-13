class Serialosc < Formula
  desc "Opensound control server for monome devices"
  homepage "https://github.com/monome/docs/blob/gh-pages/serialosc/osc.md"
  # pull from git tag to get submodules
  url "https://github.com/monome/serialosc.git",
      tag:      "v1.4.7",
      revision: "94d457f80fe3721d21df5190c99bd522c711185a"
  license "ISC"
  head "https://github.com/monome/serialosc.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9f99630d252d5bf043ab3cd20bbfe7f523f8a5947c24116884805d3f7ce4966e"
    sha256 cellar: :any,                 arm64_sequoia: "df8f10238c9b1db61937d5e6c08c05b4c1e90e452397f375ad789b8ee40b93eb"
    sha256 cellar: :any,                 arm64_sonoma:  "3b130c9e39d1cdcdc8fe79d7672bc19250eea7a77f9a88469c1568f5ef2dba90"
    sha256 cellar: :any,                 sonoma:        "6adb9865250752540188fad3bbd293935f7f82d431530bcdfeec4b372f27ed7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9bfe2f52193d07890dc1b74904c9b32dd9fb616d9e56deb031768dafedea448"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be67991d5ec342af372b09090ecdc048e178960b31795f438eac84f3090b3c54"
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

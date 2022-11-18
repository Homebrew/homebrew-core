class Wrk < Formula
  desc "HTTP benchmarking tool"
  homepage "https://github.com/wg/wrk"
  url "https://github.com/wg/wrk/archive/4.2.0.tar.gz"
  sha256 "e255f696bff6e329f5d19091da6b06164b8d59d62cb9e673625bdcd27fe7bdad"
  # License is modified Apache 2.0 with addition to Section 4 Redistribution:
  #
  # (e) If the Derivative Work includes substantial changes to features
  #     or functionality of the Work, then you must remove the name of
  #     the Work, and any derivation thereof, from all copies that you
  #     distribute, whether in Source or Object form, except as required
  #     in copyright, patent, trademark, and attribution notices.
  license :cannot_represent
  head "https://github.com/wg/wrk.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "a1b3e7d45aaca3cf965f73ef994a9ff7d8304013714633cae6bbc30f09482b2a"
    sha256 cellar: :any,                 arm64_monterey: "1737a2d76852d610856555bc8993e6edb3104f5a897895edf1cb3ccc696d6e27"
    sha256 cellar: :any,                 arm64_big_sur:  "e60b7b38483ad19e764bc0528ab7e7cb5af9a5361d860b4e8861c3922e154604"
    sha256 cellar: :any,                 ventura:        "82b7007814cfd40695e6500d354e357f74f27e67dd587da7fc775d8a18b16f13"
    sha256 cellar: :any,                 monterey:       "f3d502b3ada2613ff452cd8797bdc767d101c13f269c0d90c0f9e94a0596e279"
    sha256 cellar: :any,                 big_sur:        "46dfc59a95a38d1f882ad7ad148e05f3c1796131b3387397388635ef4a404573"
    sha256 cellar: :any,                 catalina:       "1c346f928ed78e9eed6b8224eff05dc0f58ea34c2415e4bc103d2ce19dea9330"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd6d51e49ac6dc2dbbb7ac18aa1569dc615f04d241491517afb427e173c3d8e8"
  end

  depends_on "luajit"
  depends_on "openssl@3"

  conflicts_with "wrk-trello", because: "both install `wrk` binaries"

  def install
    ENV.deparallelize
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version
    ENV.append_to_cflags "-I#{Formula["luajit"].opt_include}/luajit-2.1"
    args = %W[
      WITH_LUAJIT=#{Formula["luajit"].opt_prefix}
      WITH_OPENSSL=#{Formula["openssl@3"].opt_prefix}
    ]
    args << "VER=#{version}" unless build.head?
    system "make", *args
    bin.install "wrk"
  end

  test do
    system "#{bin}/wrk", "-c", "1", "-t", "1", "-d", "1", "https://example.com/"
  end
end

class Wrk < Formula
  desc "HTTP benchmarking tool"
  homepage "https://github.com/wg/wrk"
  url "https://github.com/wg/wrk/archive/refs/tags/4.2.0.tar.gz"
  sha256 "e255f696bff6e329f5d19091da6b06164b8d59d62cb9e673625bdcd27fe7bdad"
  # License is modified Apache 2.0 with addition to Section 4 Redistribution:
  #
  # (e) If the Derivative Work includes substantial changes to features
  #     or functionality of the Work, then you must remove the name of
  #     the Work, and any derivation thereof, from all copies that you
  #     distribute, whether in Source or Object form, except as required
  #     in copyright, patent, trademark, and attribution notices.
  license :cannot_represent
  revision 2
  head "https://github.com/wg/wrk.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "06fe612a3956378aa2a053a68e4193eacd2a9b4920629dce86c3c2d93f21ca63"
    sha256 cellar: :any,                 arm64_sequoia: "169ac7e696799e9560768a27efbebd3353da1fc29be58a1b706291a3123f2600"
    sha256 cellar: :any,                 arm64_sonoma:  "cd3c60462408a5d2a7da99ad8f6a1729e56bf740a0477a43f47e6b498d14f2d3"
    sha256 cellar: :any,                 sonoma:        "db507aacb7511160b02eb7461dc3b2e1edcc0e17dbcb63104e76650ab68c0b1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b621c87065df5a55e9b7ade043906a8fd81df8e524091df3a00f830f7ee2eea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "196ad088bc4aa989e6b94a26183d89197d071894b6c3bdf56ebfdba940c3826e"
  end

  depends_on "luajit"
  depends_on "openssl@4"

  def install
    ENV.deparallelize
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version.to_s if OS.mac?
    ENV.append_to_cflags "-I#{Formula["luajit"].opt_include}/luajit-2.1"
    args = %W[
      WITH_LUAJIT=#{Formula["luajit"].opt_prefix}
      WITH_OPENSSL=#{Formula["openssl@4"].opt_prefix}
    ]
    args << "VER=#{version}" if build.stable?
    system "make", *args
    bin.install "wrk"
  end

  test do
    system bin/"wrk", "-c", "1", "-t", "1", "-d", "1", "https://example.com/"
  end
end

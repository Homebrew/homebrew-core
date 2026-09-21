class Xaric < Formula
  desc "IRC client"
  homepage "https://xaric.org/"
  url "https://xaric.org/software/xaric/releases/xaric-0.13.10.tar.gz"
  sha256 "8f270165f3b12cffb5bacf2dcdd507e2939bd4815936cf670a1fb68142b341b0"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://xaric.org/software/xaric/releases/"
    regex(/href=.*?xaric[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "564cf4cde94b7e34c6d8a966efdcd34df89b9bd0687a64a88b63459f0744c183"
    sha256 arm64_tahoe:       "e581c7b2ec029eda76b688009874961b5b81e854355f8fb30c4617dc1e1160c4"
    sha256 arm64_sequoia:     "65349a2ed4d52d08f3aca03ac6c5b186c3bc86a78b79f894202a986b7ee1c7ae"
    sha256 arm64_linux:       "b0159c15b6a20389c511fe65ee6e9e3e45e2adb6214a18da8d6ffdb2d35a7097"
    sha256 x86_64_linux:      "03f1958f1f49aac09e320b0c8e022681039d25a3538ccbffc2a88d6e3256a29a"
  end

  depends_on "openssl@4"

  uses_from_macos "ncurses"

  def install
    # Workaround for newer Clang
    ENV.append_to_cflags "-Wno-implicit-int" if DevelopmentTools.clang_build_version >= 1403

    system "./configure", "--with-openssl=#{formula_opt_prefix("openssl@4")}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    require "pty"
    output = ""
    PTY.spawn(bin/"xaric", "-v") do |r, _w, _pid|
      r.each_line { |line| output += line }
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
    assert_match "Xaric #{version}", output
  end
end

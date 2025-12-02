class Znapzend < Formula
  desc "ZFS backup with remote capabilities and mbuffer integration"
  homepage "https://www.znapzend.org/"
  url "https://github.com/oetiker/znapzend/releases/download/v0.23.2/znapzend-0.23.2.tar.gz"
  sha256 "69928caacde7468e5154d81197e257cd0c85ee3eedb3192be67fdfe486defefe"
  license "GPL-3.0-or-later"
  head "https://github.com/oetiker/znapzend.git", branch: "master"

  # The `stable` URL uses a download from the GitHub release, so the release
  # needs to exist before the formula can be version bumped. It's more
  # appropriate to check the GitHub releases instead of tags in this context.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f04b481b943342f0ffe5a58835319c20820041f31311f29547f16e6ef72366e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "405bbba19b8422e333e11f67f73eb0c61a66150e551428f0c04b12aca2c1db99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd97162625dcc01bf084c870bdf6fd3ba45e3e0967c9b5108fec6cef9f11919b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d72402cd84c52f88fe2fcd86892efdd79f379ac886ef71fcf4143651d1e190db"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c9f4aaa841ce75048b37c4c1c54a6860f40903f2e2463c8bbb5f95c1994d3b2"
    sha256 cellar: :any_skip_relocation, ventura:       "f6273d56bb1e0c20ded2d6f4079cf7548dfd99bbab933ab4fc0b4cffae136869"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e713956866b46b71f518756ae9590023be91a54fa339a80fa05b30b6989ed43c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b66995be03c18d0b108924cc165fc08c19eb6ac27c4810669af9187ef16d7c99"
  end

  uses_from_macos "perl", since: :big_sur

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
    (var/"log/znapzend").mkpath
    (var/"run/znapzend").mkpath
  end

  service do
    run [opt_bin/"znapzend", "--connectTimeout=120", "--logto=#{var}/log/znapzend/znapzend.log"]
    environment_variables PATH: std_service_path_env
    keep_alive true
    require_root true
    error_log_path var/"log/znapzend.err.log"
    log_path var/"log/znapzend.out.log"
    working_dir var/"run/znapzend"
  end

  test do
    fake_zfs = testpath/"zfs"
    fake_zfs.write <<~SH
      #!/bin/sh
      for word in "$@"; do echo $word; done >> znapzendzetup_said.txt
      exit 0
    SH
    chmod 0755, fake_zfs
    ENV.prepend_path "PATH", testpath

    system bin/"znapzendzetup", "list"

    assert_equal <<~EOS, (testpath/"znapzendzetup_said.txt").read
      list
      -H
      -o
      name
      -t
      filesystem,volume
    EOS
  end
end

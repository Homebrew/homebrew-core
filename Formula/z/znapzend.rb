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
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ea799c57b440adbdc77ba6ac320986ddaa9982a6d040f06e628199801a1e0d90"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8fd88085dc29488d60953ff5a8ef5b3a9caf44c65b3416e7075e3c69b1ff12ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28986d6e5249820a854bd781ab6c86bc3c3805e981ecbe9008c846ebb9690682"
    sha256 cellar: :any_skip_relocation, sonoma:        "e20d2953b88bce6a242c79f3185b59338ee3d91dfc5cbf157009a695ca5d6f8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "476a5b5219ae8a7df5feaa10ccedbbc9917b4ceb39985ea731cf8e5046d86395"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5e6733464d84b87cf38f5cf1bd1d91d22c18ddceefc2ccda442c3f197418bb9"
  end

  uses_from_macos "perl", since: :big_sur

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
    (var/"log/znapzend").mkpath
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

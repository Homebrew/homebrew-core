class Znapzend < Formula
  desc "ZFS backup with remote capabilities and mbuffer integration"
  homepage "https://www.znapzend.org/"
  url "https://github.com/oetiker/znapzend/releases/download/v0.21.0/znapzend-0.21.0.tar.gz"
  sha256 "c9218f8540269a85d83b4d9159b7990ce074bac5f56566049ba355fd45ab16c5"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "851d5b6216c7083c7d4d3e164f1bd60ec2b2fdaf28a8f1ef186d2a61666a95e3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "712e06398c1865796cc896a7d8c0d6c0baf4c10a52ac5006cc4c8d69b6359fcb"
    sha256 cellar: :any_skip_relocation, monterey:       "a07b9bdb9006c9e2ef7ca1eec263c177fd6347e864a92f46df781f7d70d94353"
    sha256 cellar: :any_skip_relocation, big_sur:        "03e855b5e75b84add0bd121a3f729112c7874ee09c74c2408479e1df095bc96c"
    sha256 cellar: :any_skip_relocation, catalina:       "d4a36c0209fcb921c565bc9430ecf7a13ef3cfd226e32090c67af215c67b28ca"
    sha256 cellar: :any_skip_relocation, mojave:         "2435d387ff28213402b816f40fdbf34bb733db8216ca72e66459b188d9e25ae5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d434f71ee8faa538bbf39b2cc6c328274d9f45873098f03bd7f4b2b33b05da40"
  end

  uses_from_macos "perl"

  def install
    system "./configure", "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def post_install
    (var/"log/znapzend").mkpath
    (var/"run/znapzend").mkpath
  end

  plist_options startup: true
  service do
    run [opt_bin/"znapzend", "--connectTimeout=120", "--logto=#{var}/log/znapzend/znapzend.log"]
    environment_variables PATH: std_service_path_env
    keep_alive true
    error_log_path var/"log/znapzend.err.log"
    log_path var/"log/znapzend.out.log"
    working_dir var/"run/znapzend"
  end

  test do
    fake_zfs = testpath/"zfs"
    fake_zfs.write <<~EOS
      #!/bin/sh
      for word in "$@"; do echo $word; done >> znapzendzetup_said.txt
      exit 0
    EOS
    chmod 0755, fake_zfs
    ENV.prepend_path "PATH", testpath
    system "#{bin}/znapzendzetup", "list"
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

class Znapzend < Formula
  desc "ZFS backup with remote capabilities and mbuffer integration"
  homepage "https://www.znapzend.org/"
  url "https://github.com/oetiker/znapzend/releases/download/v0.21.1/znapzend-0.21.1.tar.gz"
  sha256 "1b438816a9a647a5bb3282ad26a6a8cd3ecce0a874f2fb506cbc156527e188f7"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12f39e6dd76784910e3db0296309bdeaf5edc3c71872c4b47e27dc6aae018efb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6cc4e37853b49ca05491ecf1736b2dc9b670e50763b45252ef93f9ca7ed0eb7a"
    sha256 cellar: :any_skip_relocation, monterey:       "9eefd9fcafcf5e7cf5966e5970a808431672d1ee939e6db175348f696234ffc9"
    sha256 cellar: :any_skip_relocation, big_sur:        "13449e4ddb4e8235101837cb6c170ffca97260a76f22774020e7cc534946a27d"
    sha256 cellar: :any_skip_relocation, catalina:       "8c30fbfdf41fbbd7ae1a45ca4e7de4c9787c826cc67209d50f0df27e91247e63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf73cdc45c34661115e3f47ddc267410917fcd5543fb8ecd46e5eb06d32c7e14"
  end

  uses_from_macos "perl", since: :big_sur

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

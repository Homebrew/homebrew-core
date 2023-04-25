class Znapzend < Formula
  desc "ZFS backup with remote capabilities and mbuffer integration"
  homepage "https://www.znapzend.org/"
  url "https://github.com/oetiker/znapzend/releases/download/v0.21.2/znapzend-0.21.2.tar.gz"
  sha256 "c3753d663c2f4d87f87da0191441c5cd2cb32aca7ded913d97565472413e3823"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "360e1da87dca16e4aee394895811672b1ff5b2cd2f0d00faf19626c227560653"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2603328f0b6bf5f6264933a29fa014bf766b39c2dca01005633f61d525712772"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "74bec9f6200da20da80c4b23090b4a75ea1813d764082965f21ecfddee02cbf2"
    sha256 cellar: :any_skip_relocation, ventura:        "70c703197262f392c2aa298aa6a12e84369a1a63d7f19b76685c39d905831f4d"
    sha256 cellar: :any_skip_relocation, monterey:       "73849373fd9725c332045cf2b2a32303336b077ad77642d9a8131b7b9b78bce8"
    sha256 cellar: :any_skip_relocation, big_sur:        "013467cb38cdce3691d36b5bc572320be8b1b2fd10c97ac0d3c7470ed8098154"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "890ef09e8f87edfcd4b93061daf11250604bb39c027bf71ab77acb357d0a239a"
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

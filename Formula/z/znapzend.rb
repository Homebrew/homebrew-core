class Znapzend < Formula
  desc "ZFS backup with remote capabilities and mbuffer integration"
  homepage "https://www.znapzend.org/"
  url "https://github.com/oetiker/znapzend/releases/download/v0.23.0/znapzend-0.23.0.tar.gz"
  sha256 "e6cef1b8eb2ee3a8d286616779f19c52e3ee042094d9c9f376fd6c086a42a091"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e4a41f3d27cb69b7a6f450839b3e5648a0bd71505a2450878070958b9a89fdd4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "35779d2320ef769397f8521ff193670353c7c6a4495f0022114aa2925e6534d3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4100c82ded93ec73240d0ad972296ca4b51e8b4e4d23d191f7ed74816fc16ef"
    sha256 cellar: :any_skip_relocation, sonoma:         "0010a95ca7ba4bc12c62954266b685a6d80edcbede5c4218d44bc932300bb10b"
    sha256 cellar: :any_skip_relocation, ventura:        "e0b1f9b8203b07ccd978db5cbd5eea347b0401877b0e51395c1feab62b827ac1"
    sha256 cellar: :any_skip_relocation, monterey:       "584e879590b61c583a868913c3d963f7a4bef650dcb3912beab809cbfc5655e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "655a9a5a5d7ebf4104be79df075f52bc715325e692d5a44250bef742416f8fff"
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

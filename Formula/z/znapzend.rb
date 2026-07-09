class Znapzend < Formula
  desc "ZFS backup with remote capabilities and mbuffer integration"
  homepage "https://www.znapzend.org/"
  url "https://github.com/oetiker/znapzend/releases/download/v0.23.6/znapzend-0.23.6.tar.gz"
  sha256 "2b8903544b4013e3f059afa4812d20bc9d889d7ffda5a8fc5b7728f36599767a"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5aa6f0226f94f813871cb07c350b43070fe34670d1f1d140b9fe9089b6176de8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61c38517d722d3fa4d195c911a52dc3c27d27cc825d0201cfbd6835fce50903d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5031431002c158ea87df165949df1c2280b161fa663ffa38bdbc87265a0072a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "68096ec47d33a9d0ccb180931aa1be8b8af900a331fc54ffb41b2b0c0178b52a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c976696b673908fe23be4d5f0c6046ac09a046c774d685ddba01d4a280593ab1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c96670acc3cbe2b425c0574b0d1918e72731d9ebdf6dc3b1888cacb90baccb8c"
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

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
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "2a9e6930ad18a76b4bf38a65dccf94f805adb88442ac6515980b936f5214836d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "894fb42d2fab9740dc12eb446afc08a6884aeff713dfedc7bb4f36758ecbc541"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d8381b64efa6aceba6574825aa1f3088fd32ffbccc0b2ebda001b6a30e8d1931"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e827d72e828c64112d249b8e138b12ab69545d3125b4a548e0b850440054d543"
    sha256 cellar: :any_skip_relocation, sonoma:         "d1a7026501925fc170e5968391f773f994cf9b0698277e7ca7b3a9c1eedd9da5"
    sha256 cellar: :any_skip_relocation, ventura:        "39cbe0e4c321ffec7a04efca7b964ce7a5b3ed3565d5d1684cda645e321eea8e"
    sha256 cellar: :any_skip_relocation, monterey:       "2fc87dc230cf7f66d84062ed1d5ffa1abe5cdb463998834edc0a717825b55a7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "fe929b8fdeac2ec5ca6feb97cc113dd160e5bd745e23ef62b8e40d0cacd4f6f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51c313e2b172e1a50338a811d4d344ff9259cd9e973b9890d7819a4bd846f352"
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

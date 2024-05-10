class Znapzend < Formula
  desc "ZFS backup with remote capabilities and mbuffer integration"
  homepage "https://www.znapzend.org/"
  url "https://github.com/oetiker/znapzend/releases/download/v0.22.0/znapzend-0.22.0.tar.gz"
  sha256 "95bf10167237522857c0fcdc5e3dfa096c4b5767bdd3c5fc8b1a1a36131dd43e"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "47b21adc983d32471a8545df6058164d77d0091f77adae3cd41922b9107bce9b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eae60061717e9656c517a6f6edf73a87621a6f19dc7c5743d659a40c64e37252"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c89f7853aaee7bf7d8cb1572682089d2f82800503f350baa7aefbab983350940"
    sha256 cellar: :any_skip_relocation, sonoma:         "36e1b6df5f24d137ae6bbe22e59a6b78cd2462edf0fc8aa0a189dbc0fa20235c"
    sha256 cellar: :any_skip_relocation, ventura:        "b8856786d36fc80c195463224d3bc5681a09d7fd9c63049a13021ba879647f3a"
    sha256 cellar: :any_skip_relocation, monterey:       "e860c37a26e36f59d039764903678c2f0da5910cd848747295018928b8613d03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1fa9d2e614e6968d752971818e80b46e3c4ed72b85e7ff1130451b37a39da74e"
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

class Vlmcsd < Formula
  desc "KMS Emulator in C"
  homepage "https://github.com/Wind4/vlmcsd"
  url "https://github.com/Wind4/vlmcsd/archive/refs/tags/svn1113.tar.gz"
  version "svn1113"
  sha256 "62f55c48f5de1249c2348ab6b96dabbe7e38899230954b0c8774efb01d9c42cc"
  license "LGPL-2.1-or-later"
  head "https://github.com/Wind4/vlmcsd.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "47d7c9405f1932a71b0554b886d164d79639cf0a1d130a7fb94ea99b0d3a8403"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "42bed0ef59c540a54cc77bf71002b8229414ed077be0bceecd568fe37b33a4be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0ea7a29e62f3886e4c495c373cf3976109b0e08010d1c28ace15f9bfc426238f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "58a2efe9d5940bc384b74ed21b81599146942ea924e9844a7b6060558f8ca621"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20f3ba285635e158a02b7cb528e25eda9fa45b6a832f5893536e88b6e965a332"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7b3abfda639485474805f9d4d93f2c6e47efacd9e8affbed3aca44bda55c1964"
    sha256 cellar: :any_skip_relocation, sonoma:         "c0e148f84144ce1029dab23c1edf9c99e9e630eddb73ad99f8651a78c0639393"
    sha256 cellar: :any_skip_relocation, ventura:        "dea463c5c77779229911e99d092d97a3cda08e557c262b23feed1764ef718b89"
    sha256 cellar: :any_skip_relocation, monterey:       "46d9330798889d87f2e2013b99fed4416124fa119d59591aadc7ebd80197c024"
    sha256 cellar: :any_skip_relocation, big_sur:        "4e7ff7a7b2b24f12671783aba5e87a444576418ec0220d037dbe25d5f1e2ff71"
    sha256 cellar: :any_skip_relocation, catalina:       "1b6375150a6cbd27eb386f0fae0bcbbccdfc9b3079dc6cfb5a9ce633029d5484"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "dcc3d4b4374dc513a4e3d307eb104d756007f820dad447357f21706185a46a88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8bacd07ef0cda2ea4ad4c5d7274b97bf8b067b69fd4412d20272b0d1c8828d1c"
  end

  deprecate! date: "2024-12-31", because: :repo_archived
  disable! date: "2025-12-31", because: :repo_archived

  uses_from_macos "llvm" => :build

  def install
    system "make", "CC=clang"
    bin.install "bin/vlmcsd"
    bin.install "bin/vlmcs"
    (etc/"vlmcsd").mkpath
    etc.install "etc/vlmcsd.ini" => "vlmcsd/vlmcsd.ini"
    etc.install "etc/vlmcsd.kmd" => "vlmcsd/vlmcsd.kmd"
    man1.install "man/vlmcs.1"
    man7.install "man/vlmcsd.7"
    man8.install "man/vlmcsd.8"
    man5.install "man/vlmcsd.ini.5"
    man1.install "man/vlmcsdmulti.1"
  end

  def caveats
    <<~EOS
      The default port is 1688

      To configure vlmcsd, edit
        #{etc}/vlmcsd/vlmcsd.ini
      After changing the configuration, please restart vlmcsd
        launchctl unload #{launchd_service_path}
        launchctl load #{launchd_service_path}
      Or, if you don't want/need launchctl, you can just run:
        brew services restart vlmcsd
    EOS
  end

  service do
    run [opt_bin/"vlmcsd", "-i", etc/"vlmcsd/vlmcsd.ini", "-D"]
    keep_alive false
  end

  test do
    output = shell_output("#{bin}/vlmcsd -V")
    assert_match "vlmcsd", output
    output = shell_output("#{bin}/vlmcs -V")
    assert_match "vlmcs", output
    begin
      pid = fork do
        exec bin/"vlmcsd", "-D"
      end
      # Run vlmcsd, then use vlmcs to check
      # the running status of vlmcsd
      sleep 2
      output = shell_output("#{bin}/vlmcs")
      assert_match "successful", output
      sleep 2
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end

class Vlmcsd < Formula
  desc "KMS Emulator in C"
  homepage "https://github.com/Wind4/vlmcsd"
  url "https://github.com/Wind4/vlmcsd/archive/svn1113.tar.gz"
  version "svn1113"
  sha256 "62f55c48f5de1249c2348ab6b96dabbe7e38899230954b0c8774efb01d9c42cc"
  head "https://github.com/Wind4/vlmcsd.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=["']?[^"' >]*?/tag/([^"' >]+)["' >]}i)
    strategy :github_latest
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20f3ba285635e158a02b7cb528e25eda9fa45b6a832f5893536e88b6e965a332"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7b3abfda639485474805f9d4d93f2c6e47efacd9e8affbed3aca44bda55c1964"
    sha256 cellar: :any_skip_relocation, monterey:       "46d9330798889d87f2e2013b99fed4416124fa119d59591aadc7ebd80197c024"
    sha256 cellar: :any_skip_relocation, big_sur:        "4e7ff7a7b2b24f12671783aba5e87a444576418ec0220d037dbe25d5f1e2ff71"
    sha256 cellar: :any_skip_relocation, catalina:       "1b6375150a6cbd27eb386f0fae0bcbbccdfc9b3079dc6cfb5a9ce633029d5484"
    sha256 cellar: :any_skip_relocation, mojave:         "d2b0cccd86ab053118aebc1885b362130b7c7e0f73f3b60c768e4907532254cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8bacd07ef0cda2ea4ad4c5d7274b97bf8b067b69fd4412d20272b0d1c8828d1c"
  end

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
        launchctl unload #{plist_path}
        launchctl load #{plist_path}
      Or, if you don't want/need launchctl, you can just run:
        brew services restart vlmcsd
    EOS
  end

  service do
    run [bin/"vlmcsd", "-i", etc/"vlmcsd/vlmcsd.ini", "-D"]
    keep_alive false
  end

  test do
    output = shell_output("#{bin}/vlmcsd -V")
    assert_match "vlmcsd", output
    output = shell_output("#{bin}/vlmcs -V")
    assert_match "vlmcs", output
    begin
      pid = fork do
        exec "#{bin}/vlmcsd", "-D"
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

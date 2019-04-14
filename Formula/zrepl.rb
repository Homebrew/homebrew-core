class Zrepl < Formula
  desc "One-stop ZFS backup & replication solution"
  homepage "https://zrepl.github.io"
  url "https://github.com/zrepl/zrepl/archive/v0.1.1.tar.gz"
  head "https://github.com/zrepl/zrepl.git"
  sha256 ""
  depends_on "go" => :build

  devel do
    url "https://github.com/zrepl/zrepl/archive/problame/fix-io-timeout-despite-heartbeats.zip"
  end
  def install
    contents = Dir["{*,.git,.gitignore}"]
    gopath = buildpath/"gopath"
    (gopath/"src/github.com/zrepl/zrepl").install contents

    ENV["GOPATH"] = gopath
    ENV.prepend_create_path "PATH", gopath/"bin"
    
    cd gopath/"src/github.com/zrepl/zrepl" do
      system "./lazy.sh",  "godep"
      system "make"
      bin.install "artifacts/zrepl"
    end      
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test zrepl`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end

class Ungit < Formula
  desc "Easiest way to use Git. On any platform. Anywhere"
  homepage "https://github.com/FredrikNoren/ungit"
  url "https://registry.npmjs.org/ungit/-/ungit-1.5.28.tgz"
  sha256 "51f2e120f7b4ceb88ff19c7debf77877d50363f15df07d2df1235257387858af"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "f3c29e0ac2bf9111ce8f2e1537df51535cec6e7b517b6d111b10644f72bfe3e2"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    port = free_port

    fork do
      exec bin/"ungit", "--no-launchBrowser", "--port=#{port}"
    end
    sleep 15

    assert_includes shell_output("curl -s 127.0.0.1:#{port}/"), "<title>ungit</title>"
  end
end

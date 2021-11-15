class Weaver < Formula
  desc "Command-line tool for Weaver"
  homepage "https://github.com/scribd/Weaver"
  url "https://github.com/scribd/Weaver/archive/1.0.7.tar.gz"
  sha256 "600a49ea7dbe58f57bf40afb7be7a42fb382ce41d807549e427b23e8504d5e02"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63fb091fc3e723145f224db88ec2e2744ff1623347fef2b455e9a36375694d90"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bb850cf17b8647754ec204c75491cae42e2ca5dcd907155f5c37902bfc2918de"
    sha256 cellar: :any_skip_relocation, monterey:       "1747df2e79d12eceef248f2faef237ed577e1bd07febed75ec729c6dd03a037b"
    sha256 cellar: :any_skip_relocation, big_sur:        "9546559d2fbfd8fbb74d6cb0f319418c2f6bec511a3ddb4e284b0195ac8a338b"
    sha256 cellar: :any_skip_relocation, catalina:       "a0b1284a91a4647fa7b3c980fc237b0677e959c821d62ca31a5b3ea8a63abf40"
    sha256 cellar: :any_skip_relocation, mojave:         "3db8730a06cb3ddd12a35097239afd85ea365c3e291a73422f37f23955230007"
  end

  depends_on xcode: ["11.2", :build]

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # Weaver uses Sourcekitten and thus, has the same sandbox issues.
    # Rewrite test after sandbox issues investigated.
    # https://github.com/Homebrew/homebrew/pull/50211
    system "#{bin}/weaver", "version"
  end
end

class Weaver < Formula
  desc "Command-line tool for Weaver"
  homepage "https://github.com/scribd/Weaver"
  url "https://github.com/scribd/Weaver/archive/1.1.5.tar.gz"
  sha256 "746b0506fdae675bfa0ef0353f38f1ab5ac6ba465bd17f85cb7b9561fb4e1da1"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "18271d928a18de578b57515c52fb2db65f7ec5c8ecd76974a988ca270e25bb39"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0b5dd663a8738e1777b6acc5212aaac5ba79013eabc4ce18ff1bc463973805f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "148f7278888814aaaee36d0872f0f9388ceeaf6adb683eb45af244ad610bd1d7"
    sha256 cellar: :any_skip_relocation, ventura:        "f5a4abb08354b0c75c2262fb0323f3569135ee5bbca26280217f0b85f958d387"
    sha256 cellar: :any_skip_relocation, monterey:       "d12fd6ecec7e13b818fd10541afc24d831f00a51ce97a363ce478bce0b56e08d"
    sha256 cellar: :any_skip_relocation, big_sur:        "228b96d7ae5ba078df562ed8d543a75aa4e63250b94598cbe849292605693dcf"
  end

  depends_on xcode: ["11.2", :build]

  uses_from_macos "swift"

  conflicts_with "service-weaver", because: "both install a `weaver` binary"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # Weaver uses Sourcekitten and thus, has the same sandbox issues.
    # Rewrite test after sandbox issues investigated.
    # https://github.com/Homebrew/homebrew/pull/50211
    system bin/"weaver", "version"
  end
end

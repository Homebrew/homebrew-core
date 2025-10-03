class Wait4x < Formula
  desc "Wait for a port or a service to enter the requested state"
  homepage "https://wait4x.dev"
  url "https://github.com/wait4x/wait4x/archive/refs/tags/v3.5.1.tar.gz"
  sha256 "8ad5b52600ded2da358417a72770221e6725fe8111b5544e2f4f4f56bfbba924"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c661495b9181dd8d402cee57fbad522741236ea5bdd32ba1fd47090b9952c8a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c332c506fc01fe00d2250543d820d66af2299d6b66d6c12a9568695b2cc0d2a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d3ba989af40f12d644e1f4f41cc95dd891e4a61580b55a128a28ee78a5c58a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "abe1208358e27d9dca38d1843a9eb60a1e0e12f7a6eeb2e20c7d39e8dfb41deb"
    sha256 cellar: :any_skip_relocation, sonoma:        "4627e9ac14d474d52ebdf789f5ac61cbe0ab2f3668735b975a5cc3f5df204c21"
    sha256 cellar: :any_skip_relocation, ventura:       "11e830e92a35adb3bf9df18a9033cb1ed8c0d47cf022c42003364332974e37b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ff5be4438415a81ed779edba2aecbb3a700cd4a79f22071d90f154ec8fbe95f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84c647841954c7d58134006391eed3ed921577a25a0250f7a7a7a2634eea1476"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "dist/wait4x"
  end

  test do
    system bin/"wait4x", "exec", "true"
  end
end

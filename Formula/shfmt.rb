class Shfmt < Formula
  desc "Autoformat shell script source code"
  homepage "https://github.com/mvdan/sh"
  url "https://github.com/mvdan/sh/archive/v3.4.2.tar.gz"
  sha256 "2000656613bc4165fb1d419bedec08fcb23a625274f4505e303d18b204d8f5ee"
  license "BSD-3-Clause"
  head "https://github.com/mvdan/sh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0de39f63c01876ea44edaf5f1db58ca6bad15ba851de3bc1065b0b71b2f9ee22"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f90de59d503c1c39372f8020bdd9433a15bd543a4e27e5937f74a12972c18e92"
    sha256 cellar: :any_skip_relocation, monterey:       "eae6fc1c573d7624cc282b24580272e2d77397b90340b4e5f1129d44aadcbdbd"
    sha256 cellar: :any_skip_relocation, big_sur:        "a7fb4f0b937883ff6367db892986823efc894d67ea77514fd88a8d49d95c87d1"
    sha256 cellar: :any_skip_relocation, catalina:       "41d8f6bf716a000fa3c5f36720d4c22e23951cba71b619716fe5e792eee7ab38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c13c9a6d768d8fda58e741ff1148baa2d5ca1d9ae9d96bb2441a818f045285b8"
  end

  depends_on "go" => :build
  depends_on "scdoc" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    (buildpath/"src/mvdan.cc").mkpath
    ln_sf buildpath, buildpath/"src/mvdan.cc/sh"
    system "go", "build", "-a", "-tags", "production brew", "-ldflags",
                          "-w -s -extldflags '-static' -X main.version=#{version}",
                          "-o", "#{bin}/shfmt", "./cmd/shfmt"
    man1.mkpath
    system "scdoc < ./cmd/shfmt/shfmt.1.scd > #{man1}/shfmt.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shfmt  --version")

    (testpath/"test").write "\t\techo foo"
    system "#{bin}/shfmt", testpath/"test"
  end
end

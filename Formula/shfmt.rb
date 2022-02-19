class Shfmt < Formula
  desc "Autoformat shell script source code"
  homepage "https://github.com/mvdan/sh"
  url "https://github.com/mvdan/sh/archive/v3.4.3.tar.gz"
  sha256 "8bfb7cc980164bfeeedd2f8866e6af23c31a4720965601a5b777a14783dfe031"
  license "BSD-3-Clause"
  head "https://github.com/mvdan/sh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d16adb18028a2bf572104d383a081d513ec3c608e2ea9dfd44fccf20c1e7b0f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3eaff57d43b2b12b276a866e693fc76597091b6580b484cb27beb0f5b7a30f43"
    sha256 cellar: :any_skip_relocation, monterey:       "b4508d0a67b4a5802fa2cb9875687ec933c2369395521b23b89faf4e7eb53cad"
    sha256 cellar: :any_skip_relocation, big_sur:        "b6765390c7387bb16bfa4fb63bb75bedf346bd2f42e70b2042c88230e668bd70"
    sha256 cellar: :any_skip_relocation, catalina:       "ab7bb4cf991a41eecda3fca4bef473dd711a62b89d906f3861515b8ec1386c98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ed1ad0c691990dd7bc6bc1665f5c47f6815b73ad28e7d97bce07af69b28f962"
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

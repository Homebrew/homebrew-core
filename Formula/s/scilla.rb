class Scilla < Formula
  desc "DNS, subdomain, port, directory enumeration tool"
  homepage "https://github.com/edoardottt/scilla"
  url "https://github.com/edoardottt/scilla/archive/refs/tags/v1.3.3.tar.gz"
  sha256 "d3d767422c371bdbeda0f674f658b22b538c5dbc88ae4b449d8bfcb351b734d4"
  license "GPL-3.0-or-later"
  head "https://github.com/edoardottt/scilla.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "968a6a0a37bf3b81c4fc81e7f9d0efb785804ec0985592df6539928b3cf0611e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "968a6a0a37bf3b81c4fc81e7f9d0efb785804ec0985592df6539928b3cf0611e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "968a6a0a37bf3b81c4fc81e7f9d0efb785804ec0985592df6539928b3cf0611e"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb32cbea3e5b752249679b19271065d1f162db6e10ed3d134fbbf9755743df2d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf1bbd9b3cccf8550bcb1c314a148dda1b345d2c197fb50a18cc7cee65ac2d9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f3039444e569c1e56d1db44299961cbe0262f39875faaea24cb804616d33f02"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/scilla"
  end

  test do
    output = shell_output("#{bin}/scilla dns -target brew.sh")
    assert_match <<~EOS, output
      =====================================================
      target: brew.sh
      ================ SCANNING DNS =======================
    EOS

    assert_match version.to_s, shell_output("#{bin}/scilla --help 2>&1", 1)
  end
end

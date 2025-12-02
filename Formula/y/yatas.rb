class Yatas < Formula
  desc "Tool to audit AWS/GCP infrastructure for misconfiguration or security issues"
  homepage "https://github.com/padok-team/yatas"
  url "https://github.com/padok-team/yatas/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "53abe26a7025aabf73918e3153c66d91cc5567e2fcd6df388e7c82e36704bd0e"
  license "Apache-2.0"
  head "https://github.com/padok-team/yatas.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "38a23bdfc24c39424fae9ad0c654b18805b54f7ab481c42161700a55a74cf670"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "6e5ba8ff412e6b856410c206db19c24ddbb66ddcaf3ef3052d47b63e11d16974"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1e1e7442a54bc2fb49b02ccdffc667bc6a7b1a08d6a16972d694d35d67835f25"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4db5b9d8b52eff80c2c3b6ef4e8ebdd2f206692804b961b1245074c4c0f1dfd8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "219b31d30c3bee4f44eba3fed594d225f548b49b0c2bf9d296903bc5e34d6c32"
    sha256 cellar: :any_skip_relocation, sonoma:         "0e7132974c379b09fb4fb6f6cce468a97a70864b64b6e8e4783a1065984af1df"
    sha256 cellar: :any_skip_relocation, ventura:        "42d9961c8cb3b440eec7d5d9cb0d611ac7ec5dde3c1a845aed8a2ba68cd06aee"
    sha256 cellar: :any_skip_relocation, monterey:       "38b5fbfb98ec19de1f03514fb8f0a6282579590fa2870025bd242bdb9908a490"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "bd2adbf69a9d5840e85f72f11e8e22fd351251cb6a6ccda1a9d7b9aaa7119cd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2ca56303f4479b8b29e123412cc62fabe88b188443466e7281f62eeab43d674"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"yatas", "--init"
    output = shell_output("#{bin}/yatas --install 2>&1")
    assert_match "failed to refresh cached credentials, no EC2 IMDS role found", output
  end
end

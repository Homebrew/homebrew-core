class ServiceWeaver < Formula
  desc "Programming framework for writing and deploying cloud applications"
  homepage "https://serviceweaver.dev/"
  license "Apache-2.0"

  stable do
    url "https://github.com/ServiceWeaver/weaver/archive/refs/tags/v0.19.0.tar.gz"
    sha256 "92fdd1e5776eb304d7b2bdbaa315bdd5f8ec4f22460d1a6c4cb97022fbe072cf"

    resource "weaver-gke" do
      url "https://github.com/ServiceWeaver/weaver-gke/archive/refs/tags/v0.19.0.tar.gz"
      sha256 "f37c59f59bc7d18dbf9c1ac46e750153ffc138b449c9df39c30d93fcb1194396"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef458ab0fed152717a3737c6e6ebedc76f646057e34717585f3a1279859139e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "486b9aa197c292e8795a60cd8c380c66a8a216226e99d76f0b80ab308bf37a84"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "83ba39e73d74ecfa90c790e498616910e94fab17f7a90429f650f71ee5e2cf81"
    sha256 cellar: :any_skip_relocation, ventura:        "7c2f930a207c4a761177d56e33a787e65d5b17bdafc159084c65e2bb49843b4b"
    sha256 cellar: :any_skip_relocation, monterey:       "9c12e53f8b33771aff01b3167c90aeff82335bbd0c44ab6ab05648ff21086e0b"
    sha256 cellar: :any_skip_relocation, big_sur:        "234ca4e62ee5184e26ddc0010c9ecc16d744ffa7db400886bc38cba839acb9d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0532ab3d52be57d47a838f781ca1214b6b214e0be88469bbcbba7ff49d46fac7"
  end

  head do
    url "https://github.com/ServiceWeaver/weaver.git", branch: "main"

    resource "weaver-gke" do
      url "https://github.com/ServiceWeaver/weaver-gke.git", branch: "main"
    end
  end

  depends_on "go" => :build

  conflicts_with "weaver", because: "both install a `weaver` binary"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"weaver"), "./cmd/weaver"
    resource("weaver-gke").stage do
      ["weaver-gke", "weaver-gke-local"].each do |f|
        system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/f), "./cmd/#{f}"
      end
    end
  end

  test do
    output = shell_output("#{bin}/weaver single status")
    assert_match "DEPLOYMENTS", output

    gke_output = shell_output("#{bin}/weaver gke status 2>&1", 1)
    assert_match "gcloud not installed", gke_output

    gke_local_output = shell_output("#{bin}/weaver gke-local status 2>&1", 1)
    assert_match "connect: connection refused", gke_local_output
  end
end

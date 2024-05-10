class VulsioGost < Formula
  desc "Local CVE tracker & notification system"
  homepage "https://github.com/vulsio/gost"
  url "https://github.com/vulsio/gost/archive/refs/tags/v0.4.5.tar.gz"
  sha256 "2a76fb45307d2fd3f13fe3eff096b91f1b669dd18c6a0dc02a6951764d61c0e7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fd0cf6c27a0ffa0c1e19fc1fabc88a8a29efdfc3a38f244ec38aaae5a32a4e6e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "645f39ac41d1759d4d1fc1752f2b402b7d104c6a53bfc012ab22cc7d8bbf0ebf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53984651214c75bf652b2a217e157410c79d062c35ffd517bde68174159e9ec5"
    sha256 cellar: :any_skip_relocation, sonoma:         "aa538c63cfbe96adf509afabc06d6f0f4b0aff9cdc1c3f0624011443ff1f0ee1"
    sha256 cellar: :any_skip_relocation, ventura:        "0f7a31a84529d0257b8f00458ed3f11a602a14ac88498f2559c6a2d1bf480643"
    sha256 cellar: :any_skip_relocation, monterey:       "6eb7036d1f5c1d9b3ef062a604d40a5b7064c57ea18f398521575029ffe0e020"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3b53548bf113b485ab313fc6b92a40aa753f4810af8443f6168b0a428946673"
  end

  depends_on "go" => :build

  conflicts_with "gost", because: "both install `gost` binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/vulsio/gost/config.Version=#{version}
      -X github.com/vulsio/gost/config.Revision=#{tap.user}
    ]
    system "go", "build", *std_go_args(output: bin/"gost", ldflags:)

    generate_completions_from_executable(bin/"gost", "completion", base_name: "gost")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gost version")

    output = shell_output("#{bin}/gost fetch debian 2>&1")
    assert_match "Fetched all CVEs from Debian", output
  end
end

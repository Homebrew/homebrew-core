class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
    tag:      "v0.33.11",
    revision: "670651de706f64e29df933dfc468cd66bc543eea"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b729988897e9211c173c1d33fa0f6c73bc04697abbc3b257c9dc7d1e20582383"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c353c95d67c361bf7535c28db2cc2374279dfad66bd8e8a8d96757be24c87038"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3493edd96151c4a8b975663f9f52f54bd5a8977fd68ce7fc474427c0b1441113"
    sha256 cellar: :any_skip_relocation, sonoma:         "6914c7fa66d167a7006f6ca1d685dfddeccc2519350ebe05ec3fec38ab49ae2b"
    sha256 cellar: :any_skip_relocation, ventura:        "27ca500cdd2bf614fe9a61a77b18a990cbba229a0bb048373df682cc4a662d65"
    sha256 cellar: :any_skip_relocation, monterey:       "ad78398b640eb44931149110613403efcfc3c3b211e33ed82df659a8877720eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b238997bb7a831a82ad405aec3bc72aee29a2661c94259d2d4af1529f60c0799"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    # bundling the frontend assets first will allow them to be embedded into
    # the final build
    system "yarn", "config", "set", "ignore-engines", "true" # allow our newer node
    system "make", "build-js"

    ENV["CGO_ENABLED"] = "1"
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/tilt"

    generate_completions_from_executable(bin/"tilt", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tilt version")

    assert_match "Error: No tilt apiserver found: tilt-default", shell_output("#{bin}/tilt api-resources 2>&1", 1)
  end
end

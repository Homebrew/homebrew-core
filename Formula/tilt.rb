class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
    tag:      "v0.31.2",
    revision: "179ba4c7b21bc5924aecab129b58ff1ac662f98e"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8642a7cf8146190bfefe90139eb63f936ead1ea404cf44fb722190ad2037be81"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a17f671c6c4547f95ca2c45159eecb2493d002288982ecfcc974316aa34c2eb0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "444298cdc2fe9166c9590563ea25a37946cc53af41e480d3a18978362b324c81"
    sha256 cellar: :any_skip_relocation, ventura:        "50785febb58c2ed6600552946b65e4701ff72db3b9f8e1513d6de2c9da055c35"
    sha256 cellar: :any_skip_relocation, monterey:       "e2e3641dff1ec75c9303f5a8a49f16be55d098b226847a38f7d4407e2cc2f743"
    sha256 cellar: :any_skip_relocation, big_sur:        "1896a3d96e1d0fac57fd9b82c4ec68ba045ca55c6cabe42973384f6a5aaa5e7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e50e5c198da2273aed8b458a9cd00118e191765b89418e261f39e160fd54d62"
  end

  depends_on "go" => :build
  depends_on "node@16" => :build
  depends_on "yarn" => :build

  def install
    # bundling the frontend assets first will allow them to be embedded into
    # the final build
    system "make", "build-js"

    ENV["CGO_ENABLED"] = "1"
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.iso8601}
    ].join(" ")
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/tilt"

    generate_completions_from_executable(bin/"tilt", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tilt version")

    assert_match "Error: No tilt apiserver found: tilt-default", shell_output("#{bin}/tilt api-resources 2>&1", 1)
  end
end

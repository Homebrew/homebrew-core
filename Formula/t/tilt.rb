class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
      tag:      "v0.34.5",
      revision: "0b2f9287b2900a854f0e474a10b2f8496a857ff7"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50700b10519453046b074ef94fe983543fa7e547acf2e40ecad9672ee80cda73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d62e2b6a4797fb58944e00d063d31ad67e8d436c4830f7ef79ad3a4007b5418"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c48ba2a219909ebda580824da9126d69bb08a7a062e357cfb4906d63e5406454"
    sha256 cellar: :any_skip_relocation, sonoma:        "db39ef09e74e2ee75f164d3ff90a5c289f4e0c5419b9636f6dc97749f97b588e"
    sha256 cellar: :any_skip_relocation, ventura:       "c294090151ebbad8ae1aeca12573f7b365a030c21c4291c6436e8e0f32cb8c71"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ffb6524dac9087097f754d352c5bdc2cd02583dd1cdf73dfa3f4a8788c8845f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eed76e76a3368a0372321099a6f69530d764739e7ff524fa4ca56a1e1727e369"
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

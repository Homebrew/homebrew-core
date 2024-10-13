class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
    tag:      "v0.33.20",
    revision: "73707128f97c6f5ddfa0a530f664c2e238eb03a3"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "068a83c13bf0ca0d9983a9ed9fadf0d2693628360b14a2d3e933c58e220f38e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8891ad14c958156fdddd309550df66de6c57f64e39c8c6b90e98da8b56ee866f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "efe5e9af44122535ebc0ba55176feec05f63c16b8117ff1a77ff9ed7c356d7be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84c39a244a146695468ca2d49eeb3d2a42ddb1f353d969e94b6a8a10123d00ab"
    sha256 cellar: :any_skip_relocation, sonoma:         "e0cd9fa0b63f57cbc9f248de39b5c159e875b9513284b84d7d97c25961eedd08"
    sha256 cellar: :any_skip_relocation, ventura:        "164afd93851ef7719f325e4adf00bae188fe5367c8967ea7e86c423b858e43fd"
    sha256 cellar: :any_skip_relocation, monterey:       "6ec200fc5bf94e676b6e279f9ac727ee4ab3517ce2c778fc70263f3b6144d983"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b5f125709b8bfc5b6ae7c987484b1be000d5041659c9382f16bec98de5bc46c"
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

class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
    tag:      "v0.30.12",
    revision: "812e45674c2b35f359a4690b01c6a9ea5d42e214"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad5e5a2e6b9f738dd1eb99657c739901764492ca4d54b3a55d57cce110d0299a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a38d0551e58610eb0e0e3bac62fb039ed8c5fa6088333b4e6552ecaa34312b46"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "221e48cc0b31bf498062616602545ec9731a2bba8b472030ba6ce7c60b32b705"
    sha256 cellar: :any_skip_relocation, ventura:        "1b7c94b98319691b10c803c504d88f1b7d6d5a86a5930081f6e53e55f47559c5"
    sha256 cellar: :any_skip_relocation, monterey:       "8ac1f26e22943ce59103516ca8e7323fd9df3d06c59373329aa578eb25211d3d"
    sha256 cellar: :any_skip_relocation, big_sur:        "6bcc677257eb67cab67f7aac87248a1402124d11060829d4426369d1bfed8c30"
    sha256 cellar: :any_skip_relocation, catalina:       "efb5d267b70a3a56dbbb88a51290ec7fbdd88c0aab7c8d604345340b8f0e8b11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cdd67e915d05164605e1aea92bb5d341ae02bad8ec698c7aa729b26327551527"
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

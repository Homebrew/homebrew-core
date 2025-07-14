class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
      tag:      "v0.35.0",
      revision: "f43ca2120a05906725b67493f6cf35b23ec720bf"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b7344fa92f5c70786363895f3b645e3c61931c9caccf0626d475328011b74fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75dd54cbace4f4015d5bbda7e77e3d5ee8fbbd5ec4136e9d68454e08cf394551"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "11825fd334495af98c442aa0b96296079089adbb45197a42ab8f4ac0ccc53740"
    sha256 cellar: :any_skip_relocation, sonoma:        "345b4ca5ad5774d82902be83121f61d7f770c77494aa967fe281ae02faf7c602"
    sha256 cellar: :any_skip_relocation, ventura:       "2ef1ef73d26e0da1cd5dc3417ae02ae166580840c63ffba5aef2439c1cb22d70"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e6c06864c7c59e455b37771184adff8a7d7cfa04ee219af54e9b09d050e9c1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f25a94814af709f571afa043434bfbd4a8068e38d73e1c289f9f7727b416fb30"
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

class Terradozer < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://github.com/jckuester/terradozer"
  url "https://github.com/jckuester/terradozer.git",
      tag:      "v0.1.3",
      revision: "d42c8adee62ca06f1a8acf32c9834cf3cb703dd1"
  license "MIT"
  head "https://github.com/jckuester/terradozer.git", branch: "master"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jckuester/terradozer/internal.version=#{version}
      -X github.com/jckuester/terradozer/internal.commit=#{Utils.git_head}
      -X github.com/jckuester/terradozer/internal.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    (testpath/"tfstate.json").write <<~EOS
      {
        "version": 3,
        "terraform_version": "0.12.24",
        "serial": 1,
        "lineage": "ccb8c8b5-3a1c-c49e-5beb-3cae83d7975d",
        "modules": [{
          "path": [
            "root"
          ],
          "depends_on": []
        }]
      }
    EOS

    assert_match "SHOWING RESOURCES THAT WOULD BE DELETED (DRY RUN)",
      shell_output("AWS_PROFILE=test #{bin}/terradozer -dry-run tfstate.json 2>&1")

    assert_match version.to_s, shell_output("#{bin}/terradozer -version")
  end
end

class Skopeo < Formula
  desc "Work with remote images registries"
  homepage "https://github.com/containers/skopeo"
  url "https://github.com/containers/skopeo/archive/refs/tags/v1.15.1.tar.gz"
  sha256 "4db9798afd45e3282f35ddad3e494db99231e84470f30d6b105a3ed687e67ee0"
  license "Apache-2.0"

  bottle do
    sha256 arm64_sonoma:   "7331d8f94bceb8ba15e7614cbb711ea0153f0e2e951bafb203e05c1c417920ca"
    sha256 arm64_ventura:  "9a0f072f0f3a08cc3e286717ef4651ac3be0c63f2d5f1101d411c8a12d3ac55c"
    sha256 arm64_monterey: "c4257a9968bd222a7aa9962714e4d2d2fe7105cf32b7d3489e35a4c962ddd672"
    sha256 sonoma:         "09bf7986a3670f92c24a803bbb954f5af00b9305839d864e707a9f0bba96ab7c"
    sha256 ventura:        "650bcc0ea0dbc87e77d67d5dd221f0dd01da29d91b100d87d903558ea88d47ac"
    sha256 monterey:       "0616a1489531e817b2e0890dbc388e1f71fe947280cc62fa1ce00e696c7ebbdf"
    sha256 x86_64_linux:   "a6a4f54c762a2f9478e97a2b71895f935e71e619cecdfaba92ad16dfbe01999f"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build
  depends_on "pkg-config" => :build
  depends_on "gpgme"

  on_linux do
    depends_on "device-mapper"
  end

  def install
    ENV["CGO_ENABLED"] = "1"
    ENV.append "CGO_FLAGS", ENV.cppflags
    ENV.append "CGO_FLAGS", Utils.safe_popen_read(Formula["gpgme"].opt_bin/"gpgme-config", "--cflags")

    buildtags = [
      "containers_image_ostree_stub",
      Utils.safe_popen_read("hack/btrfs_tag.sh").chomp,
      Utils.safe_popen_read("hack/btrfs_installed_tag.sh").chomp,
      Utils.safe_popen_read("hack/libdm_tag.sh").chomp,
    ].uniq.join(" ")

    ldflag_prefix = "github.com/containers/image/v5"
    ldflags = %W[
      -X main.gitCommit=
      -X #{ldflag_prefix}/docker.systemRegistriesDirPath=#{etc}/containers/registries.d
      -X #{ldflag_prefix}/internal/tmpdir.unixTempDirForBigFiles=/var/tmp
      -X #{ldflag_prefix}/signature.systemDefaultPolicyPath=#{etc}/containers/policy.json
      -X #{ldflag_prefix}/pkg/sysregistriesv2.systemRegistriesConfPath=#{etc}/containers/registries.conf
    ]

    system "go", "build", "-tags", buildtags, *std_go_args(ldflags:), "./cmd/skopeo"
    system "make", "PREFIX=#{prefix}", "GOMD2MAN=go-md2man", "install-docs"

    (etc/"containers").install "default-policy.json" => "policy.json"
    (etc/"containers/registries.d").install "default.yaml"

    generate_completions_from_executable(bin/"skopeo", "completion")
  end

  test do
    cmd = "#{bin}/skopeo --override-os linux inspect docker://busybox"
    output = shell_output(cmd)
    assert_match "docker.io/library/busybox", output

    # https://github.com/Homebrew/homebrew-core/pull/47766
    # https://github.com/Homebrew/homebrew-core/pull/45834
    assert_match(/Invalid destination name test: Invalid image name .+, expected colon-separated transport:reference/,
                 shell_output("#{bin}/skopeo copy docker://alpine test 2>&1", 1))
  end
end

class Skopeo < Formula
  desc "Work with remote images registries"
  homepage "https://github.com/containers/skopeo"
  url "https://github.com/containers/skopeo/archive/v1.0.0.tar.gz"
  sha256 "df5f38ee72e2fede508d1fd272a48773b86eb6bc6cc4b7b856a99669d22fa5df"

  bottle do
    sha256 "f3dc8e83805ba461b4a090e8976c1f71460cc50d49dcd5bca12398f0b8d03d2a" => :catalina
    sha256 "89bfa2ed6f0779e63c214393278082589e98e708ab138ce5c71194d38b096e88" => :mojave
    sha256 "34aae1e77e56d17e0c4050750d1c2aec74c38a57adcbd494d8f557022685dafc" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "gpgme"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV["CGO_ENABLED"] = "1"
    ENV.append "CGO_FLAGS", ENV.cppflags
    ENV.append "CGO_FLAGS", Utils.popen_read("#{Formula["gpgme"].bin}/gpgme-config --cflags")

    (buildpath/"src/github.com/containers/skopeo").install buildpath.children
    cd buildpath/"src/github.com/containers/skopeo" do
      buildtags = [
        "containers_image_ostree_stub",
        Utils.popen_read("hack/btrfs_tag.sh").chomp,
        Utils.popen_read("hack/btrfs_installed_tag.sh").chomp,
        Utils.popen_read("hack/libdm_tag.sh").chomp,
        Utils.popen_read("hack/ostree_tag.sh").chomp,
      ].uniq.join(" ")

      ldflags = [
        "-X main.gitCommit=",
        "-X github.com/containers/image/v5/docker.systemRegistriesDirPath=#{etc/"containers/registries.d"}",
        "-X github.com/containers/image/v5/internal/tmpdir.unixTempDirForBigFiles=/var/tmp",
        "-X github.com/containers/image/v5/signature.systemDefaultPolicyPath=#{etc/"containers/policy.json"}",
        "-X github.com/containers/image/v5/pkg/sysregistriesv2.systemRegistriesConfPath=" \
                                              "#{etc/"containers/registries.conf"}",
      ].join(" ")

      system "go", "build", "-v", "-x", "-tags", buildtags, "-ldflags", ldflags, "-o", bin/"skopeo", "./cmd/skopeo"

      (etc/"containers").install "default-policy.json" => "policy.json"
      (etc/"containers/registries.d").install "default.yaml"

      bash_completion.install "completions/bash/skopeo"

      prefix.install_metafiles
    end
  end

  test do
    cmd = "#{bin}/skopeo --override-os linux inspect docker://busybox"
    output = shell_output(cmd)
    assert_match "docker.io/library/busybox", output

    # https://github.com/Homebrew/homebrew-core/pull/47766
    # https://github.com/Homebrew/homebrew-core/pull/45834
    assert_match /Invalid destination name test: Invalid image name .+, expected colon-separated transport:reference/,
                 shell_output("#{bin}/skopeo copy docker://alpine test 2>&1", 1)
  end
end

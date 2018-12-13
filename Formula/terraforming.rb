class Terraforming < Formula
  desc "Export existing AWS resources to Terraform style (tf, tfstate)"
  homepage "https://terraforming.dtan4.net/"
  url "https://github.com/dtan4/terraforming.git",
      :tag      => "v0.16.0",
      :revision => "a38e73739ff7ed5261abebabe08aced770bcd84c"

  bottle do
    cellar :any_skip_relocation
    sha256 "0057055c61a6d42d25133fe3816a5d6d32117c179f93ecbc9f22e36d5fff2a2d" => :mojave
    sha256 "e0725b2299c049d2ff8e2f05c40b4ed26c4425a2db80edadd522d5a3fe74d02f" => :high_sierra
    sha256 "9be52ca74b16d7b408370e3cdea144fe8a422cc3678981d13dde72968aedb71b" => :sierra
    sha256 "55ae998ef2c0bbcf4f45964136c89eefc477f8ac1992d03c89b6413409846ecc" => :el_capitan
  end

  resource "aws-sdk-autoscaling" do
    url "https://rubygems.org/gems/aws-sdk-autoscaling-1.3.0.gem"
    sha256 "35ad92666e75f4fc17bbc312efcf459c604f4505737b6c6287ce55b579e9ce5d"
  end

  resource "aws-sdk-cloudwatch" do
    url "https://rubygems.org/gems/aws-sdk-cloudwatch-1.2.0.gem"
    sha256 "3c40aa67e5f7e32be3bd63daff6056a753dd7f2938e955960784a74d5be33908"
  end

  resource "aws-sdk-ec2" do
    url "https://rubygems.org/gems/aws-sdk-ec2-1.10.0.gem"
    sha256 "5bc356c5e38e3e482563e40525c7fd1bb2791d847b970329b1b0688aa0aa628e"
  end

  resource "aws-sdk-efs" do
    url "https://rubygems.org/gems/aws-sdk-efs-1.0.0.gem"
    sha256 "91e12fcb58cc42b0a67263867c3bff9a7da8496e1312a51e1b9db991627b817c"
  end

  resource "aws-sdk-elasticache" do
    url "https://rubygems.org/gems/aws-sdk-elasticache-1.1.0.gem"
    sha256 "1cf9a2b9124b3490ee6aa2d5328b0144f70de45565def4605cbea5b26753d5af"
  end

  resource "aws-sdk-elasticloadbalancing" do
    url "https://rubygems.org/gems/aws-sdk-elasticloadbalancing-1.1.0.gem"
    sha256 "a819b8427733f06cd83fe41a912e953b5503a61d857d3b9f9548d7801c3e9534"
  end

  resource "aws-sdk-elasticloadbalancingv2" do
    url "https://rubygems.org/gems/aws-sdk-elasticloadbalancingv2-1.3.0.gem"
    sha256 "e578163969e152dca6ee538dc958218d66e8cad00d8dd8332609bb95ea7566cc"
  end

  resource "aws-sdk-iam" do
    url "https://rubygems.org/gems/aws-sdk-iam-1.3.0.gem"
    sha256 "e724ac129db6d5c7e9ec43c1fb1ca47abb1490a9e8013d0be9501f1660324ba6"
  end

  resource "aws-sdk-kms" do
    url "https://rubygems.org/gems/aws-sdk-kms-1.2.0.gem"
    sha256 "4a76cbd7a9e605e52d1851fd38c4121a29e5aa7c18f0a6eab816842598765fa9"
  end

  resource "aws-sdk-rds" do
    url "https://rubygems.org/gems/aws-sdk-rds-1.4.0.gem"
    sha256 "a7116634bb8645f8c288748f44207f97364e8358b4f8743a9df16cf1b3a8d637"
  end

  resource "aws-sdk-redshift" do
    url "https://rubygems.org/gems/aws-sdk-redshift-1.1.0.gem"
    sha256 "f4622f0c4a6f3b04f5b3e6b27bca4baccca94a2db6708f60da6df9defe7e8d86"
  end

  resource "aws-sdk-route53" do
    url "https://rubygems.org/gems/aws-sdk-route53-1.3.0.gem"
    sha256 "98299ba6d3d8c9a54fdab9dec71a2ac409277bdcd187fce4d7012caa4d5aff46"
  end

  resource "aws-sdk-s3" do
    url "https://rubygems.org/gems/aws-sdk-s3-1.5.0.gem"
    sha256 "6efcfc8249a1de4b4626c603ae5190b30b3762fbc5ed6536caa483a4c262328e"
  end

  resource "aws-sdk-sns" do
    url "https://rubygems.org/gems/aws-sdk-sns-1.1.0.gem"
    sha256 "253cb65bebcfd6d2d6650899335c4b71a2d977adad53eeae21467800892cd79b"
  end

  resource "aws-sdk-sqs" do
    url "https://rubygems.org/gems/aws-sdk-sqs-1.2.0.gem"
    sha256 "ab48397ecb46909607afb3e7f1fa171fcc7e9d9337fac53a2825b3241ca51a9d"
  end

  resource "multi_json" do
    url "https://rubygems.org/gems/multi_json-1.12.2.gem"
    sha256 "5dcc0b569969f3d1658c68b5d597fcdc1fc3a34d4ae92b4615c740d95aaa51e5"
  end

  resource "thor" do
    url "https://rubygems.org/gems/thor-0.20.0.gem"
    sha256 "b47dad86e151c08921cf935c1ad2be4d9982e435784d6bc223530b62a4bfb85a"
  end

  def install
    ENV["GEM_HOME"] = libexec
    resources.each do |r|
      r.verify_download_integrity(r.fetch)
      system "gem", "install", r.cached_download, "--no-document",
             "--install-dir", libexec
    end
    system "gem", "build", "terraforming.gemspec"
    system "gem", "install", "--ignore-dependencies",
           "terraforming-#{version}.gem"
    bin.install libexec/"bin/terraforming"
    bin.env_script_all_files(libexec/"bin", :GEM_HOME => ENV["GEM_HOME"])
  end

  test do
    output = shell_output("#{bin}/terraforming help ec2")
    assert_match "Usage:", output
    assert_match "terraforming ec2", output
  end
end

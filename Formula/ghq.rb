class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/motemen/ghq"
  url "https://github.com/motemen/ghq.git",
      :tag      => "v0.14.2",
      :revision => "f56ab202a9775a8e469a1b4e158231f3e81d0e77"
  head "https://github.com/motemen/ghq.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a04277cb220930791a67f14217477d7e7cce730df2649247f64830777063f02f" => :catalina
    sha256 "8c96a802da841a7f86a849d70de53f727702a3f5233b73fef4c45c6ec0a9d141" => :mojave
    sha256 "8ae0017f9ba9da87ddbf925b7fcdc8c2bbfe670717e1a437271afd28694c9920" => :high_sierra
    sha256 "a52530cb9647f94542e61a830351321d8355c07669d538568e80169060f399ca" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "ghq"
    zsh_completion.install "zsh/_ghq"
    prefix.install_metafiles
  end

  test do
    assert_match "#{testpath}/.ghq", shell_output("#{bin}/ghq root")
  end
end

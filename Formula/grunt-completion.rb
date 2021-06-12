class GruntCompletion < Formula
  desc "Bash and Zsh completion for Grunt"
  homepage "https://gruntjs.com/"
  url "https://github.com/gruntjs/grunt-cli/archive/v1.4.3.tar.gz"
  sha256 "3bf07d807d61adbf04fa93589a7dd58fbc4da7a5f1febfd8a99b3ccb0d682009"
  license "MIT"
  head "https://github.com/gruntjs/grunt-cli.git"

  def install
    bash_completion.install "completion/bash" => "grunt"
    zsh_completion.install "completion/zsh" => "_grunt"
  end

  test do
    assert_match "-F _grunt_completions",
      shell_output("source #{bash_completion}/grunt && complete -p grunt")
  end
end

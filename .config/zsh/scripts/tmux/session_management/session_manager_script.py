import fire
import subprocess


def create_subprocess(command):
    """
    Creates a subprocess for the string `command`
    """
    return subprocess.run(command, shell=True,
                          text=True, check=True, stdout=subprocess.PIPE)


def create():
    # Final session name store
    final_session_name = ""
    try:
        # Confirm if you want to create a new space or choose a scope
        create_subprocess("gum confirm \"Choose scope?\" && echo \"True\"")
        # Get all ongoing courses
        ongoing = create_subprocess("echo \"Choose the scope of this new tmux space\""
                                    "&& cat ongoing_courses.txt | gum filter")
        chosen = ongoing.stdout.strip().split("\n")[1]
        # Ask if you want to add any extensions to the name
        extension = create_subprocess(
            "gum input --placeholder \"Enter extension, if any.\"",)
        extension = "_" + extension.stdout.strip()
        extension = "" if extension == "_" else extension
        # Construct final session name
        final_session_name = chosen + extension
    except Exception:
        # Ask for custom session name
        custom_name = create_subprocess(
            "gum input --placeholder \"Enter custom tmux session name.\"",)
        final_session_name = custom_name.stdout.strip()

    # Create new tmux session with final name
    create_subprocess(f"tmux new-session -d -s \"{final_session_name}\""
                      f"&& tmux switch -t \"{final_session_name}\""
                      )
    print("Created new tmux session: " + final_session_name)


if __name__ == "__main__":
    fire.Fire(create)

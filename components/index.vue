<template>
    <div class="index">
        {{ $gettext('Первое сообщение, смотрю сюда') }}
        {{ $gettext('Второе сообщение, смотрю сюда') }}
        {{ $gettext('Третье сообщение, смотрю сюда') }}
    </div>
</template>

<script>
import {Layout} from '@/const/storybook'

export default {
    name: `${Layout}index`,
}
</script>
